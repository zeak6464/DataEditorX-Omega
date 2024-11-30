--LP Manipulation Effect Template
local s,id=GetID()
function s.initial_effect(c)
    --Set LP to specific value
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.lptg)
    e1:SetOperation(s.lpop)
    c:RegisterEffect(e1)
    
    --Exchange LP with opponent
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.exchtg)
    e2:SetOperation(s.exchop)
    c:RegisterEffect(e2)
    
    --Make LP equal
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.eqtg)
    e3:SetOperation(s.eqop)
    c:RegisterEffect(e3)
    
    --Prevent LP changes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_LOSE_LP)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(s.target)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end

function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(4000)
end

function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.SetLP(p,d)
end

function s.exchtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end

function s.exchop(e,tp,eg,ep,ev,re,r,rp)
    local lp1=Duel.GetLP(tp)
    local lp2=Duel.GetLP(1-tp)
    Duel.SetLP(tp,lp2)
    Duel.SetLP(1-tp,lp1)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLP(tp)~=Duel.GetLP(1-tp) end
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local lp1=Duel.GetLP(tp)
    local lp2=Duel.GetLP(1-tp)
    local nlp=math.max(lp1,lp2)
    Duel.SetLP(tp,nlp)
    Duel.SetLP(1-tp,nlp)
end

function s.target(e,c)
    return c==e:GetHandler()
end
