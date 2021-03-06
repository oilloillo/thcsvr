--落とし穴
function c990002.initial_effect(c)
    --Activate(summon)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c990002.target)
    e1:SetOperation(c990002.activate)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)

    if c990002.counter == nil then
        c990002.counter = true
        Uds.regUdsEffect(e1,990002)
        Uds.regUdsEffect(e2,990002)
    end
end
function c990002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if not eg then return false end
    local tc=eg:GetFirst()
    if chkc then return chkc==tc end
    if chk==0 then return ep~=e:GetOwnerPlayer() and tc:IsFaceup() and tc:GetAttack()>=1000 and tc:IsOnField()
        and tc:IsCanBeEffectTarget(e) and tc:IsDestructable() end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c990002.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>=1000 then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
