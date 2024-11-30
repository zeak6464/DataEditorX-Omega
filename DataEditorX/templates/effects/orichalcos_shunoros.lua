--Orichalcos Shunoros and Divine Serpent Template
local s,id=GetID()
function s.initial_effect(c)
    --Special Summon with Kyutora
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --ATK gain from damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SET_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)
    --Special Summon Divine Serpent
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(s.spcon2)
    e3:SetTarget(s.sptg2)
    e3:SetOperation(s.spop2)
    c:RegisterEffect(e3)
end
s.listed_names={CARD_ORICHALCOS_KYUTORA,CARD_DIVINE_SERPENT}

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
        and e:GetHandler():IsPreviousPosition(POS_FACEUP)
end

function s.spfilter(c,e,tp)
    return c:IsCode(CARD_ORICHALCOS_SHUNOROS) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end

--Store accumulated damage
s.accumulated_damage=0

function s.atkval(e,c)
    return s.accumulated_damage
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end

function s.spfilter2(c,e,tp)
    return c:IsCode(CARD_DIVINE_SERPENT) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 then
        --Cannot lose the duel
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_LOSE_LP)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        --Special infinite ATK/DEF handling
        local tc=g:GetFirst()
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_BASE_ATTACK)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetValue(-1) --Special value representing infinity
        tc:RegisterEffect(e2)
        local e3=e2:Clone()
        e3:SetCode(EFFECT_SET_BASE_DEFENSE)
        tc:RegisterEffect(e3)
        --Battle handling
        local e4=Effect.CreateEffect(e:GetHandler())
        e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
        e4:SetRange(LOCATION_MZONE)
        e4:SetCondition(s.damcon)
        e4:SetOperation(s.damop)
        tc:RegisterEffect(e4)
        --Cannot be destroyed by battle
        local e5=Effect.CreateEffect(e:GetHandler())
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e5:SetValue(1)
        tc:RegisterEffect(e5)
    end
end

--Condition for battle damage
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:GetAttack()>=0 and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end

--Operation for battle damage
function s.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if not bc then return end
    if c==Duel.GetAttacker() then
        if bc:IsPosition(POS_ATTACK) then
            local dam=8000 --Maximum LP damage
            Duel.Damage(1-tp,dam,REASON_BATTLE)
        end
        Duel.Destroy(bc,REASON_BATTLE)
    else
        if bc:IsPosition(POS_ATTACK) then
            local dam=8000 --Maximum LP damage
            Duel.Damage(1-tp,dam,REASON_BATTLE)
        end
        Duel.Destroy(bc,REASON_BATTLE)
    end
    --Prevent normal battle damage calculation
    Duel.ChangeBattleDamage(tp,0)
    Duel.ChangeBattleDamage(1-tp,0)
end
