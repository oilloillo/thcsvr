 
--七曜-日水符「氢化日珥」
function c888185.initial_effect(c)
	--d&d
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888185,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c888185.target)
	e4:SetOperation(c888185.operation)
	c:RegisterEffect(e4)
end
function c888185.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c888185.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c888185.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingTarget(c888185.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	local g=Duel.SelectTarget(tp,c888185.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c888185.spfilter(c,e,tp,tap,tc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:GetOwner()==tap and c~=tc
end
function c888185.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			local tap=tc:GetOwner()
			local g=Duel.SelectMatchingCard(tap,c888185.spfilter,tap,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,tap,tc)
			Duel.SpecialSummon(g,0,tap,tap,false,false,POS_FACEUP)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
