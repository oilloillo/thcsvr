--剑伎『樱花闪闪』
function c20197.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c20197.target)
	e1:SetOperation(c20197.activate)
	c:RegisterEffect(e1)
end
function c20197.cfilter(c)
	return c:IsSetCard(0x713) and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x201)
end
function c20197.filter(c)
	return c:GetSequence()<5
end
function c20197.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local bns=1
	if Duel.IsExistingMatchingCard(c20197.cfilter,tp,LOCATION_MZONE,0,1,nil) then bns=2 end
	if chkc then 
		if bns==2 then
			return false
		else
			return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and c20197.filter(chkc) and chkc~=e:GetHandler()
		end
	end
	if chk==0 then return Duel.IsExistingTarget(c20197.filter,tp,0,LOCATION_SZONE,bns,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20197.filter,tp,0,LOCATION_SZONE,bns,bns,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,bns,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bns*500)
end
function c20197.activate(e,tp,eg,ep,ev,re,r,rp)
	local bns=1
	if Duel.IsExistingMatchingCard(c20197.cfilter,tp,LOCATION_MZONE,0,1,nil) then bns=2 end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.Destroy(tg,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,bns*500,REASON_EFFECT)
	end
end
