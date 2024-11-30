--Zone Control Effect Template
local s,id=GetID()
function s.initial_effect(c)
    --Lock zones
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(s.disop)
    c:RegisterEffect(e1)
    
    --Move to another zone
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(s.seqtg)
    e2:SetOperation(s.seqop)
    c:RegisterEffect(e2)
    
    --Control adjacent zones
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_FORCE_MZONE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e3:SetValue(s.frcval)
    c:RegisterEffect(e3)
end

function s.disop(e,tp)
    local c=e:GetHandler()
    local seq=c:GetSequence()
    local nseq=0
    if seq<=4 then
        nseq=4-seq
    end
    return 0x1<<nseq
end

function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end

function s.seqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or not c:IsLocation(LOCATION_MZONE) then return end
    local seq=c:GetSequence()
    if seq>4 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local nseq=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0x1<<seq)
    if nseq==0 then return end
    nseq=math.log(nseq,2)
    Duel.MoveSequence(c,nseq)
end

function s.frcval(e,c,fp,rp,r)
    local c=e:GetHandler()
    local seq=c:GetSequence()
    if seq>4 then return nil end
    local zone=0
    if seq>0 then zone=zone|0x1<<(seq-1) end
    if seq<4 then zone=zone|0x1<<(seq+1) end
    return zone
end
