 
--飞头「倍增之头」
function c29037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c29037.condition)
	e1:SetTarget(c29037.target)
	e1:SetOperation(c29037.activate)
	c:RegisterEffect(e1)
end
function c29037.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c29037.filter(c,e,tp)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName==0x826 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29037.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function c29037.activate(e,tp,eg,ep,ev,re,r,rp)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if lc<=0 then return end
	local g=Duel.GetMatchingGroup(c29037.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	local lc=lc-1
	if lc>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29037,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		lc=lc-1
		if lc>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29037,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g3=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,g3:GetFirst():GetCode())
			g1:Merge(g3)
			lc=lc-1
			if lc>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29037,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				g4=g:Select(tp,1,1,nil)
				g:Remove(Card.IsCode,nil,g4:GetFirst():GetCode())
				g1:Merge(g4)
				lc=lc-1
				if lc>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29037,0)) then
					g5=g:Select(tp,1,1,nil)
					g1:Merge(g5)
				end
			end
		end
	end
	local tc=g1:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		tc=g1:GetNext()
	end
	Duel.SpecialSummonComplete()
end
