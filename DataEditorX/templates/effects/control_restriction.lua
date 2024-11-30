--Control Restriction Effect Template
--For effects that restrict control changes based on Type/Attribute
local s,id=GetID()
function s.initial_effect(c)
    --Cannot control different types/attributes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_CONTROL)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(s.controltg)
    c:RegisterEffect(e1)
    
    --Send controlled monster to grave
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CONTROL_CHANGED)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(s.controlop)
    c:RegisterEffect(e2)
end

--Check if monster can be controlled
function s.controltg(e,c)
    local tp=e:GetHandlerPlayer()
    if not c:IsControler(1-tp) then return false end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    if #g==0 then return false end
    local tc=g:GetFirst()
    local race=tc:GetRace()
    local attr=tc:GetAttribute()
    return c:IsFaceup() and (c:GetRace()~=race or c:GetAttribute()~=attr)
end

--Handle control change
function s.controlop(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    if #g==0 then return end
    local race=g:GetFirst():GetRace()
    local attr=g:GetFirst():GetAttribute()
    local sg=g:Filter(s.filter,nil,race,attr)
    if #sg>0 then
        Duel.SendtoGrave(sg,REASON_RULE)
        Duel.Readjust()
    end
end

function s.filter(c,race,attr)
    return c:GetRace()~=race or c:GetAttribute()~=attr
end
