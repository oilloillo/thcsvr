 
--铃仙
function c21029.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21029.hspcon)
	e1:SetOperation(c21029.hspop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21029,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c21029.descost)
	e2:SetTarget(c21029.destg)
	e2:SetOperation(c21029.desop)
	c:RegisterEffect(e2)
end
function c21029.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR+RACE_WINDBEAST+RACE_BEAST) and c:IsSetCard(0x208)
end
function c21029.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c21029.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c21029.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21029.spfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,POS_FACEUP,REASON_COST)
end
function c21029.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e:GetHandler():RegisterEffect(e1)
end
function c21029.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c21029.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21029.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21029.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21029.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21029.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

