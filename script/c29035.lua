 
--进击的小人
function c29035.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c29035.cost)
	e1:SetTarget(c29035.sptg)
	e1:SetOperation(c29035.spop)
	c:RegisterEffect(e1)
end
function c29035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29035)==0 end
	Duel.RegisterFlagEffect(tp,29035,RESET_PHASE+PHASE_END,0,1)
end
function c29035.spfilter(c,e,tp)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName==0x826 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanDraw(1-tp,1)
		and Duel.IsExistingMatchingCard(c29035.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c29035.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29035.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetValue(100)
		g:GetFirst():RegisterEffect(e1)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end
