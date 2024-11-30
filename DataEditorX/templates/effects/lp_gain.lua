--LP Gain Effect Template
local s,id=GetID()
function s.initial_effect(c)
    --Gain LP on Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.rectg)
    e1:SetOperation(s.recop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    
    --Gain LP during Standby Phase
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(s.reccon)
    e3:SetTarget(s.rectg2)
    e3:SetOperation(s.recop2)
    c:RegisterEffect(e3)
    
    --Gain LP based on battle damage
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,2))
    e4:SetCategory(CATEGORY_RECOVER)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_DAMAGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(s.reccon2)
    e4:SetOperation(s.recop3)
    c:RegisterEffect(e4)
end

function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end

function s.recop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end

function s.reccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end

function s.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(500)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end

function s.recop2(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end

function s.reccon2(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end

function s.recop3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(tp,ev,REASON_EFFECT)
end
