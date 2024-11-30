--Trap Monster Template
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    
    --Treat as monster
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_CHANGE_TYPE)
    e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_TRAP)
    e2:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e2)
    
    --Parameters as monster
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EFFECT_SET_BASE_ATTACK)
    e3:SetValue(1800)
    e3:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_SET_BASE_DEFENSE)
    e4:SetValue(1000)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetCode(EFFECT_CHANGE_RACE)
    e5:SetValue(RACE_FIEND)
    e5:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e6:SetValue(ATTRIBUTE_DARK)
    e6:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e7:SetCode(EFFECT_CHANGE_LEVEL)
    e7:SetValue(4)
    e7:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e7)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT+TYPE_TRAP,1800,1000,4,RACE_FIEND,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT+TYPE_TRAP,1800,1000,4,RACE_FIEND,ATTRIBUTE_DARK) then return end
    c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
