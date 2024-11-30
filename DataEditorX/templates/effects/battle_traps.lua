--Battle-related Trap Templates
local s,id=GetID()
function s.initial_effect(c)
    --Cubic Defence
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetCondition(s.cubiccon)
    e1:SetTarget(s.cubictg)
    e1:SetOperation(s.cubicop)
    c:RegisterEffect(e1)
    
    --Dragon's Orb
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetOperation(s.dragonop)
    c:RegisterEffect(e2)
    
    --Enhanced Counter
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e3:SetCondition(s.enhancecon)
    e3:SetOperation(s.enhanceop)
    c:RegisterEffect(e3)
    
    --High Speed Aria
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_ACTIVATE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCost(s.ariacost)
    e4:SetOperation(s.ariaop)
    c:RegisterEffect(e4)
    
    --Time Chain
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_ACTIVATE)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetCondition(s.timecon)
    e5:SetTarget(s.timetg)
    e5:SetOperation(s.timeop)
    c:RegisterEffect(e5)
    
    --Warrior's Devotion
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_ACTIVATE)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetCondition(s.warriorcon)
    e6:SetCost(s.warriorcost)
    e6:SetOperation(s.warriorop)
    c:RegisterEffect(e6)
end

--Cubic Defence functions
function s.cubiccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp)
end

function s.spfilter(c,e,tp,code)
    return c:IsCode(code) and c:IsCanBeSpecialSummon(e,0,tp,false,false)
end

function s.cubictg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end

function s.cubicop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttackTarget()
    if tc and tc:IsRelateToBattle() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
        tc:RegisterEffect(e1)
        if Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
            local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp,tc:GetCode())
            if #g>=2 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local sg=g:Select(tp,2,2,nil)
                Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
            end
        end
    end
end

--Dragon's Orb functions
function s.dragonop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_DISABLE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end

--Enhanced Counter functions
function s.enhancecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetBattleDamage(tp)>0
end

function s.enhanceop(e,tp,eg,ep,ev,re,r,rp)
    local dam=Duel.GetBattleDamage(tp)
    if Duel.ChangeBattleDamage(tp,0) then
        local tc=Duel.GetFirstMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        if tc then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(dam)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
            tc:RegisterEffect(e1)
        end
    end
end

--High Speed Aria functions
function s.ariacost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_SPELL+TYPE_NORMAL) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_SPELL+TYPE_NORMAL)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabelObject(g:GetFirst())
end

function s.ariaop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc then
        local te=tc:GetActivateEffect()
        if te then
            local e1=te:Clone()
            e1:SetRange(LOCATION_SZONE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e:GetHandler():RegisterEffect(e1)
        end
    end
    --Cannot activate Spells next turn
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetValue(s.aclimit)
    e2:SetReset(RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e2,tp)
end

function s.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsType(TYPE_SPELL)
end

--Time Chain functions
function s.timecon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttackTarget() and Duel.GetAttackTarget():IsControler(tp)
end

function s.timetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local at=Duel.GetAttacker()
    local tc=Duel.GetAttackTarget()
    if chk==0 then return at and tc end
    Duel.SetTargetCard(Group.FromCards(at,tc))
end

function s.timeop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if #g>0 then
        for tc in aux.Next(g) do
            --Cannot be destroyed by battle
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
            e1:SetValue(1)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
            tc:RegisterEffect(e1)
            --Treated as not on field
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,4)
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_CANNOT_ATTACK)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,4)
            tc:RegisterEffect(e3)
            local e4=Effect.CreateEffect(c)
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
            e4:SetValue(1)
            e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,4)
            tc:RegisterEffect(e4)
        end
    end
    --Self-destroy condition
    e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetCountLimit(1)
    e5:SetCondition(s.descon)
    e5:SetOperation(s.desop)
    e5:SetReset(RESET_PHASE+PHASE_STANDBY,4)
    Duel.RegisterEffect(e5,tp)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=Duel.GetTurnCount()
    if ct==e:GetLabel()+2 then
        Duel.Destroy(c,REASON_EFFECT)
    end
end

--Warrior's Devotion functions
function s.warriorcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttackTarget()==nil
end

function s.cfilter(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAbleToGraveAsCost()
end

function s.warriorcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabel(g:GetFirst():GetAttack())
end

function s.warriorop(e,tp,eg,ep,ev,re,r,rp)
    local atk=e:GetLabel()
    local tc=Duel.GetAttacker()
    if tc:IsRelateToBattle() and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end
