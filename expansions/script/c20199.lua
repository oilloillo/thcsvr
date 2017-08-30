--樱花剑『闪闪散华』
function c20199.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20199.target)
	e1:SetOperation(c20199.activate)
	c:RegisterEffect(e1)
end
function c20199.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x713)
end
function c20199.filter2(c)
	return c:IsFaceup()
end
function c20199.cfilter(c)
	return c:IsCode(20178) and c:IsFaceup()
end
function c20199.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c20199.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c20199.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c20199.filter1,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c20199.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
	local dmg=g1:GetAttack()/2
	if g1:GetEquipGroup():IsExists(c20199.cfilter,1,nil) then dmg=g1:GetAttack() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,dmg)
end
function c20199.activate(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==dc then tc=g:GetNext() end
	if dc:IsRelateToEffect(e) and Duel.Destroy(dc,REASON_EFFECT)>0 and tc:IsRelateToEffect(e) then
		local dmg=tc:GetAttack()/2
		if tc:GetEquipGroup():IsExists(c20199.cfilter,1,nil) then dmg=tc:GetAttack() end
		Duel.Damage(1-tp,dmg,REASON_EFFECT)
	end
end
