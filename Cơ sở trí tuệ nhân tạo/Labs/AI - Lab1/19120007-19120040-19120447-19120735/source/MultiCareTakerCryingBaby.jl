#CODE REFER
#Algorithms for Decision Making
#https://github.com/algorithmsbooks/DecisionMakingProblems.jl

#Import Library
using JuMP,  Ipopt
using Distributions
using Random
using LinearAlgebra, BenchmarkTools
using DecisionMakingProblems

#define constant
SING = "SING"
CRYING = "CRYING"
QUIET = "QUIET"
FEED = "FEED"
SATED = "SATED"
HUNGRY = "HUNGRY"
##########################################################

#struct define 
struct POMG
    γ  # discount factor
    ℐ  # agents
    𝒮  # state space
    𝒜  # joint action space
    𝒪  # joint observation space
    T  # transition function
    O  # joint observation function
    R  # joint reward function

    function POMG(discount, agents, states, jointAction, jointObservation, transitionFunction, jointObservationFunction, jointReward)
        new(discount, agents, states, jointAction, jointObservation, transitionFunction, jointObservationFunction, jointReward);
    end
end

struct POMGDynamicProgramming
    b # initial belief
    d # depth of conditional plans
end

struct ConditionalPlan
    a # action to take at root
    subplans # dictionary mapping observations to subplans
end

ConditionalPlan(a) = ConditionalPlan(a, Dict())

(π::ConditionalPlan)() = π.a
(π::ConditionalPlan)(o) = π.subplans[o]

function expand_conditional_plans(𝒫, Π)
    ℐ, 𝒜, 𝒪 = 𝒫.ℐ, 𝒫.𝒜, 𝒫.𝒪
    return [[ConditionalPlan(ai, Dict(oi => πi for oi in 𝒪[i]))
        for πi in Π[i] for ai in 𝒜[i]] for i in ℐ]
end

joint(X) = vec(collect(Iterators.product(X...)))
joint(π, πi, i) = [i == j ? πi : πj for (j, πj) in enumerate(π)]

struct SimpleGame
    γ  # discount factor
    ℐ  # agents
    𝒜  # joint action space
    R  # joint reward function
end

struct NashEquilibrium end

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
##########################################################

#define transition function
function transition(s, a, s′)
    # Regardless, feeding makes the baby sated.
    if a[1] == "FEED" || a[2] == "FEED"
        if s′ == "SATED"
            return 1.0
        else
            return 0.0
        end
    else
        # If neither caretaker fed, then one of two things happens.
        # First, a baby that is hungry remains hungry.
        if s == "HUNGRY"
            if s′ == "HUNGRY"
                return 1.0
            else
                return 0.0
            end
        # Otherwise, it becomes hungry with a fixed probability.
        else
            probBecomeHungry = 0.5 #pomg.babyPOMDP.p_become_hungry
            if s′ == "SATED"
                return 1.0 - probBecomeHungry
            else
                return probBecomeHungry
            end
        end
    end
end

#JOINT OBSERVERTAION FUNCTION FOR POMG STRUCT
function joint_observation(a, s′, o)
    # If at least one caregiver sings, then both observe the result.
    p_cry_when_hungry_in_sing = 0.9
    p_cry_when_hungry = 0.9
    p_cry_when_not_hungry = 0.0

    if a[1] == SING || a[2] == SING
        # If the baby is hungry, then the caregivers both observe crying/silent together.
        if s′ == HUNGRY
            if o[1] == CRYING && o[2] == CRYING
                return p_cry_when_hungry_in_sing
            elseif o[1] == QUIET && o[2] == QUIET
                return 1.0 - p_cry_when_hungry_in_sing
            else
                return 0.0
            end
        # Otherwise the baby is sated, and the baby is silent.
        else
            if o[1] == QUIET && o[2] == QUIET
                return 1.0
            else
                return 0.0
            end
        end
    # Otherwise, the caregivers fed and/or ignored the baby.
    else
        # If the baby is hungry, then there's a probability it cries.
        if s′ == HUNGRY
            if o[1] == CRYING && o[2] == CRYING
                return p_cry_when_hungry
            elseif o[1] == QUIET && o[2] == QUIET
                return 1.0 - p_cry_when_hungry
            else
                return 0.0
            end
        # Similarly when it is sated.
        else
            if o[1] == CRYING && o[2] == CRYING
                return p_cry_when_not_hungry
            elseif o[1] == QUIET && o[2] == QUIET
                return 1.0 - p_cry_when_not_hungry
            else
                return 0.0
            end
        end
    end
end

#REWARD FUNCTION FOR POMG STRUCT
function joint_reward(s, a)
    r = [0.0, 0.0]

    # Both caregivers do not want the child to be hungry.
    if s == HUNGRY
        r -= [10, 10]
    end

    # One caregiver prefers to feed.
    if a[1] == FEED
        r[1] -= 2.5
    elseif a[1] == SING
        r[1] -= 0.5
    end

    # One caregiver prefers to sing.
    if a[2] == FEED
        r[2] -= 5
    elseif a[2] == SING
        r[2] -= 0.25
    end

    # Note that caregivers only experience a cost if they do something.
    return r
end


function lookahead(𝒫::POMG, U, s, a)
    𝒮, 𝒪, T, O, R, γ = 𝒫.𝒮, joint(𝒫.𝒪), 𝒫.T, 𝒫.O, 𝒫.R, 𝒫.γ
    u′ = sum(T(s,a,s′)*sum(O(a,s′,o)*U(o,s′) for o in 𝒪) for s′ in 𝒮)
    return R(s,a) + γ*u′
end

function evaluate_plan(𝒫::POMG, π, s)
    a = Tuple(πi() for πi in π)
    U(o,s′) = evaluate_plan(𝒫, [πi(oi) for (πi, oi) in zip(π,o)], s′)
    return isempty(first(π).subplans) ? 𝒫.R(s,a) : lookahead(𝒫, U, s, a)
end

#Kiem tra xem nhanh i co bi thong tri boi nhanh nao khac hay khong
function is_dominated(𝒫::POMG, Π, i, πi)
    ℐ, 𝒮 = 𝒫.ℐ, 𝒫.𝒮
    jointΠnoti = joint([Π[j] for j in ℐ if j ≠ i])
    π(πi′, πnoti) = [j==i ? πi′ : πnoti[j>i ? j-1 : j] for j in ℐ]
    Ui = Dict((πi′, πnoti, s) => evaluate_plan(𝒫, π(πi′, πnoti), s)[i]
            for πi′ in Π[i], πnoti in jointΠnoti, s in 𝒮)
    model = Model(Ipopt.Optimizer)
    @variable(model, δ)
    @variable(model, b[jointΠnoti, 𝒮] ≥ 0)
    @objective(model, Max, δ)
    @constraint(model, [πi′=Π[i]],
        sum(b[πnoti, s] * (Ui[πi′, πnoti, s] - Ui[πi, πnoti, s])
        for πnoti in jointΠnoti for s in 𝒮) ≥ δ)
    @constraint(model, sum(b) == 1)
    optimize!(model)
    return value(δ) ≥ 0
end

#Cat bo cac nhanh policy bi "thong tri" boi mot nhanh khac
function prune_dominated!(Π, 𝒫::POMG)
    done = false
    while !done
        done = true
        for i in shuffle(𝒫.ℐ)
            for πi in shuffle(Π[i])
                if length(Π[i]) > 1 && is_dominated(𝒫, Π, i, πi)
                    filter!(πi′ -> πi′ ≠ πi, Π[i])
                    done = false
                    break
                end
            end
        end
    end
end

function tensorform(𝒫::SimpleGame)
    ℐ, 𝒜, R = 𝒫.ℐ, 𝒫.𝒜, 𝒫.R
    ℐ′ = eachindex(ℐ)
    𝒜′ = [eachindex(𝒜[i]) for i in ℐ]
    R′ = [R(a) for a in joint(𝒜)]
    return ℐ′, 𝒜′, R′
end

function solve(M::NashEquilibrium, 𝒫::SimpleGame)
    ℐ, 𝒜, R = tensorform(𝒫)
    model = Model(Ipopt.Optimizer)
    @variable(model, U[ℐ])
    @variable(model, π[i=ℐ, 𝒜[i]] ≥ 0)
    @NLobjective(model, Min,
        sum(U[i] - sum(prod(π[j,a[j]] for j in ℐ) * R[y][i]
            for (y,a) in enumerate(joint(𝒜))) for i in ℐ))
    @NLconstraint(model, [i=ℐ, ai=𝒜[i]],
        U[i] ≥ sum(
            prod(j==i ? (a[j]==ai ? 1.0 : 0.0) : π[j,a[j]] for j in ℐ)
            * R[y][i] for (y,a) in enumerate(joint(𝒜))))
    @constraint(model, [i=ℐ], sum(π[i,ai] for ai in 𝒜[i]) == 1)
    optimize!(model)
    πi′(i) = SimpleGamePolicy(𝒫.𝒜[i][ai] => value(π[i,ai]) for ai in 𝒜[i])
    return [πi′(i) for i in ℐ]
end

function utility(𝒫::POMG, b, π)
    u = [evaluate_plan(𝒫, π, s) for s in 𝒫.𝒮]
    return sum(bs * us for (bs, us) in zip(b, u))
end

#Ham giai bai toan POMG bang thuat toan Dynamic programming
function solve(M::POMGDynamicProgramming, 𝒫::POMG)
    ℐ, 𝒮, 𝒜, R, γ, b, d = 𝒫.ℐ, 𝒫.𝒮, 𝒫.𝒜, 𝒫.R, 𝒫.γ, M.b, M.d
    Π = [[ConditionalPlan(ai) for ai in 𝒜[i]] for i in ℐ]
    for t in 1:d
        Π = expand_conditional_plans(𝒫, Π)
        prune_dominated!(Π, 𝒫)
    end
    𝒢 = SimpleGame(γ, ℐ, Π, π -> utility(𝒫, b, π))
    π = solve(NashEquilibrium(), 𝒢)
    return Tuple(argmax(πi.p) for πi in π)
end

#Declare problem base on POMG struct
multicare = POMG(0.9, 
                [1, 2], 
                ["HUNGRY", "SATED"], 
                [["FEED", "SING", "IGNORE"], ["FEED", "SING", "IGNORE"]], 
                [["CRYING", "QUIET"], ["CRYING", "QUIET"]], 
                transition, 
                joint_observation, 
                joint_reward);

b = [0.5, 0.5];
dyP = POMGDynamicProgramming(b, 1);

result = solve(dyP, multicare);
print(result)