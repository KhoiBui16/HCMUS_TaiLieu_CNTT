#= Nguồn tham khảo
[1] Mykel J. Kochenderfer, Tim A. Wheeler, Kyle H. Wray. Algorithms for Decision Making, Massachusetts Institute of Technology, 2022
[2] DecisionMakingProblems.jl Repository on Github https://github.com/algorithmsbooks/DecisionMakingProblems.jl.git
=#

using Random
using Distributions
using LinearAlgebra
using Plots
# [1]
struct SetCategorical{S}
    elements::Vector{S} # Set elements (could be repeated)
    distr::Categorical # Categorical distribution over set elements
    function SetCategorical(elements::AbstractVector{S}) where S
        weights = ones(length(elements))
        return new{S}(elements, Categorical(normalize(weights, 1)))
    end
    function SetCategorical(elements::AbstractVector{S}, weights::AbstractVector{Float64}) where S
        ℓ₁ = norm(weights,1)
        if ℓ₁ < 1e-6 || isinf(ℓ₁)
            return SetCategorical(elements)
        end
        distr = Categorical(normalize(weights, 1))
        return new{S}(elements, distr)
    end
end
Distributions.rand(D::SetCategorical) = D.elements[rand(D.distr)]
Distributions.rand(D::SetCategorical, n::Int) = D.elements[rand(D.distr, n)]
function Distributions.pdf(D::SetCategorical, x)
    sum(e == x ? w : 0.0 for (e,w) in zip(D.elements, D.distr.p))
end
# [1]

# [2]
# Lớp SimpleGame
struct SimpleGame
    γ  # discount factor
    ℐ  # agents
    𝒜  # joint action space
    R  # joint reward function
end

# Đối tượng trò chơi Rock Paper Scissors
struct RockPaperScissors end
# Số người tham gia
n_agents(simpleGame::RockPaperScissors) = 2
# Tập các hành động mà mỗi người có thể lựa chọn
ordered_actions(simpleGame::RockPaperScissors, i::Int) = [:rock, :paper, :scissors]
# Bảng các hành động các cả hai người tham gia
ordered_joint_actions(simpleGame::RockPaperScissors) = vec(collect(Iterators.product([ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)]...)))
# Độ dài của ordered_actions và ordered_joint_actions
n_joint_actions(simpleGame::RockPaperScissors) = length(ordered_joint_actions(simpleGame))
n_actions(simpleGame::RockPaperScissors, i::Int) = length(ordered_actions(simpleGame, i))
# Điểm thưởng của agent i 
function reward(simpleGame::RockPaperScissors, i::Int, a)
    if i == 1
        noti = 2
    else
        noti = 1
    end

    if a[i] == a[noti]
        r = 0.0
    elseif a[i] == :rock && a[noti] == :paper
        r = -1.0
    elseif a[i] == :rock && a[noti] == :scissors
        r = 1.0
    elseif a[i] == :paper && a[noti] == :rock
        r = 1.0
    elseif a[i] == :paper && a[noti] == :scissors
        r = -1.0
    elseif a[i] == :scissors && a[noti] == :rock
        r = -1.0
    elseif a[i] == :scissors && a[noti] == :paper
        r = 1.0
    end

    return r
end
# Bảng điểm cho tất cả các trường hợp
function joint_reward(simpleGame::RockPaperScissors, a)
    return [reward(simpleGame, i, a) for i in 1:n_agents(simpleGame)]
end
# Tạo ra một SimpleGame cho trò chơi RockPaperScissors
function SimpleGame(simpleGame::RockPaperScissors)
    return SimpleGame(
        0.9,
        vec(collect(1:n_agents(simpleGame))),
        [ordered_actions(simpleGame, i) for i in 1:n_agents(simpleGame)],
        (a) -> joint_reward(simpleGame, a)
    )
end
# [2]

# [1]
# Đối tượng SimpleGamePolicy chứa phân phối xác suất của các hành động
struct SimpleGamePolicy
    p # dictionary mapping actions to probabilities
    function SimpleGamePolicy(p::Base.Generator)
        return SimpleGamePolicy(Dict(p))
    end
    function SimpleGamePolicy(p::Dict)
        vs = collect(values(p))
        vs ./= sum(vs)
        return new(Dict(k => v for (k,v) in zip(keys(p), vs)))
    end
    SimpleGamePolicy(ai) = new(Dict(ai => 1.0))
end

(πi::SimpleGamePolicy)(ai) = get(πi.p, ai, 0.0)

# Chọn ra sự lựa chọn, nếu nhiều lựa chọn thì random
function (πi::SimpleGamePolicy)()
    D = SetCategorical(collect(keys(πi.p)), collect(values(πi.p)))
    println(D)
    print(rand(D))
    return rand(D)
end

joint(X) = vec(collect(Iterators.product(X...)))
joint(π, πi, i) = [i == j ? πi : πj for (j, πj) in enumerate(π)]

# tính utility 
function utility(𝒫::SimpleGame, π, i)
    𝒜, R = 𝒫.𝒜, 𝒫.R
    p(a) = prod(πj(aj) for (πj, aj) in zip(π, a))
    return sum(R(a)[i]*p(a) for a in joint(𝒜))
end

# trả về sự lựa chọn tốt nhất
function best_response(𝒫::SimpleGame, π, i)
    U(ai) = utility(𝒫, joint(π, SimpleGamePolicy(ai), i), i)
    ai = argmax(U, 𝒫.𝒜[i])
    return SimpleGamePolicy(ai)
end

# lớp FictitiousPlay là cách chơi của mỗi người chơi
mutable struct FictitiousPlay
    𝒫 # simple game
    i # agent index
    N # array of action count dictionaries
    πi # current policy
end

# hàm tạo một FictitiousPlay
function FictitiousPlay(𝒫::SimpleGame, i)
    N = [Dict(aj => 1 for aj in 𝒫.𝒜[j]) for j in 𝒫.ℐ]
    πi = SimpleGamePolicy(ai => 1.0 for ai in 𝒫.𝒜[i])
    return FictitiousPlay(𝒫, i, N, πi)
end

(πi::FictitiousPlay)() = πi.πi()
(πi::FictitiousPlay)(ai) = πi.πi(ai)

# cập nhật cách chơi πi với sự lựa chọn a
function update!(πi::FictitiousPlay, a)
    N, 𝒫, ℐ, i = πi.N, πi.𝒫, πi.𝒫.ℐ, πi.i
    for (j, aj) in enumerate(a)
        N[j][aj] += 1
    end
    p(j) = SimpleGamePolicy(aj => u/sum(values(N[j])) for (aj, u) in N[j])
    π = [p(j) for j in ℐ]
    πi.πi = best_response(𝒫, π, i)
end
# [1]

# lưu sự lựa chọn và điểm số của từng người chơi 
function write_score!(π, score, agent, policy)
    π1, π2 = π
    p = [collect(keys(π1.πi.p))[1], collect(keys(π2.πi.p))[1]]
    res = joint_reward(RockPaperScissors(), p)
    score[1] += res[1]
    score[2] += res[2]
    push!(agent[1], score[1])
    push!(agent[2], score[2])
    for i = 1:2
        if p[i] == :rock
            push!(policy[i][1], 1)
            push!(policy[i][2], 0)
            push!(policy[i][3], 0)
        elseif p[i] == :paper
            push!(policy[i][1], 0)
            push!(policy[i][2], 1)
            push!(policy[i][3], 0)
        elseif p[i] == :scissors
            push!(policy[i][1], 0)
            push!(policy[i][2], 0)
            push!(policy[i][3], 1)
        end
    end
end

# lưu phân phối xác suất các hành động của từng người chơi
function write_prop!(π, prop)
    π1, π2 = π
    for i = 1:2
        push!(prop[i][1], (π1.N[i][:rock] / sum(values(π1.N[i]))))
        push!(prop[i][2], (π1.N[i][:paper] / sum(values(π1.N[i]))))
        push!(prop[i][3], (π1.N[i][:scissors] / sum(values(π1.N[i]))))
    end
end
# vẽ đồ thị 
function visualization(k_max, agent, prop, policy)
    # vẽ đồ thị scores of two agents
    plot(1:k_max, agent[1], title = "Scores of two agents", label = "Agent 1")
    pScore = plot!(1:k_max, agent[2], label = "Agent 2")
    xlabel!("Iteration")
    savefig(pScore, joinpath(@__DIR__, "score.png"))
    # vẽ đồ thị Opponent model of Agent 2
    plot(1:k_max, prop[1][1], title = "Opponent model of Agent 2", label = "Rock")
    pProp1 = plot!(1:k_max, prop[1][2], label = "Paper")
    pProp1 = plot!(1:k_max, prop[1][3], label="Scissors")
    xlabel!("Iteration")
    savefig(pProp1, joinpath(@__DIR__, "opponent_model2.png"))
    # vẽ đồ thị Opponent model of Agent 1
    plot(1:k_max, prop[2][1], title = "Opponent model of Agent 1", label = "Rock")
    pProp2 = plot!(1:k_max, prop[2][2], label="Paper")
    pProp2 = plot!(1:k_max, prop[2][3], label="Scissors")
    xlabel!("Iteration")
    savefig(pProp2, joinpath(@__DIR__, "opponent_model1.png"))
    # vẽ đồ thị Policy of Agent 1
    plot(1:k_max, policy[1][1], title = "Policy of Agent 1", label = "Rock")
    pPolicy1 = plot!(1:k_max, policy[1][2], label="Paper")
    pPolicy1 = plot!(1:k_max, policy[1][3], label="Scissors")
    xlabel!("Iteration")
    savefig(pPolicy1, joinpath(@__DIR__, "policy1.png"))
    # vẽ đồ thị Policy of Agent 2
    plot(1:k_max, policy[2][1], title = "Policy of Agent 2", label = "Rock")
    pPolicy2 = plot!(1:k_max, policy[2][2], label="Paper")
    pPolicy2 = plot!(1:k_max, policy[2][3], label="Scissors")
    xlabel!("Iteration")
    savefig(pPolicy2, joinpath(@__DIR__, "policy2.png"))
end

# [1]
# mô phỏng trò chơi RPS 𝒫 với π là chiến lược chơi và k_max là số lượt chơi
function simulate(𝒫::SimpleGame, π, k_max)
    # mảng chứa số điểm của 2 người chơi
    score = [0, 0] 
    # mảng chứa số điểm của 2 người chơi theo các lần chơi 
    agent = [[], []]
    # mảng chứa xác suất các hành động đã chọn của 2 người chơi theo các lần chơi 
    prop = [[[], [], []], [[], [], []]]
    # mảng chứa các lựa chọn của 2 người chơi theo các lần chơi
    policy = [[[], [], []], [[], [], []]]
    # duyệt k_max vòng
    for k = 1:k_max
        # a là mảng sự lựa chọn của 2 người chơi
        a = [πi() for πi in π]
        # cập nhật chiến lược của từng người chơi
        for πi in π
            update!(πi, a)
        end
        # lưu kết quả vào agent, prop, policy để vẽ visualization
        write_score!(π, score, agent, policy)
        write_prop!(π, prop)
    end
    # vẽ visualization
    visualization(k_max, agent, prop, policy)
    return π
end
# [1]
# gọi simulate để thực hiện trò chơi
function main()
    𝒫 = SimpleGame(RockPaperScissors())
    π1 = FictitiousPlay(𝒫, 1)
    π2 = FictitiousPlay(𝒫, 2)
    π = [π1, π2]
    simulate(𝒫, π, 10000)
end
main()