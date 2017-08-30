 
--绯想✿琪露诺
function c200017.initial_effect(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(22009)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c200017.op)
	c:RegisterEffect(e2)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c200017.tg2)
	e1:SetOperation(c200017.op2)
	c:RegisterEffect(e1)

end
function c200017.filter(c)
	local x=c:GetOriginalCode()
	return x>=200001 and x<=200020 and c:IsAbleToGrave() --and c:GetLevel()<=8
end
function c200017.rfilter(c,lv)
	return c:GetLevel()==lv
end
function c200017.op(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200117)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(c200017.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetLevel)>1 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(200017,1)) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(c200017.rfilter,nil,g1:GetFirst():GetLevel())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end
function c200017.filter2(c)
	return c:IsCode(200217) and c:IsAbleToHand()
end
function c200017.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_DESTROY)==REASON_DESTROY and Duel.IsExistingMatchingCard(c200017.filter2,tp,LOCATION_DECK,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c200017.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200017.filter2,tp,LOCATION_DECK,0,1,nil) then
		local g=Duel.GetFirstMatchingCard(c200017.filter2,tp,LOCATION_DECK,0,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)	
	end
end