 
--灭罪「正直者之死」
function c21124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c21124.target)
	e1:SetOperation(c21124.activate)
	c:RegisterEffect(e1)
end
function c21124.filter(c,e,tp)
	return (c:IsCode(21024) or c:IsCode(21077)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21124.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local a=Duel.GetAttacker()
	if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c21124.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and a:IsOnField() and a:IsDestructable() and a:IsCanBeEffectTarget(e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21124.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetTargetCard(a)
	e:SetLabelObject(a)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end
function c21124.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==a then tc=g:GetNext() end
	if a:IsRelateToEffect(e) and a:IsAttackable() and not a:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Destroy(a,REASON_EFFECT)~=0 and Duel.Damage(1-tp,500,REASON_EFFECT) and tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
