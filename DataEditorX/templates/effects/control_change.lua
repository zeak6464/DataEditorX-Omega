--Control Change Effect Template
local s,id=GetID()
function s.initial_effect(c)
    --Take control
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_CONTROL)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.cttg)
    e1:SetOperation(s.ctop)
    c:RegisterEffect(e1)
    
    --Exchange control
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.ehtg)
    e2:SetOperation(s.ehop)
    c:RegisterEffect(e2)
end

function s.ctfilter(c)
    return c:IsControlerCanBeChanged()
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.ctfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(s.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,s.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end

function s.ehfilter(c,tp)
    return c:IsControler(tp) and c:IsControlerCanBeChanged()
end

function s.ehtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(s.ehfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp)
        and Duel.IsExistingTarget(s.ehfilter,tp,0,LOCATION_MZONE,1,nil,1-tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g1=Duel.SelectTarget(tp,s.ehfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g2=Duel.SelectTarget(tp,s.ehfilter,tp,0,LOCATION_MZONE,1,1,nil,1-tp)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end

function s.ehop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetTargetCards(e)
    if #g~=2 then return end
    local a=g:GetFirst()
    local b=g:GetNext()
    if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) then
        Duel.SwapControl(a,b)
    end
end
