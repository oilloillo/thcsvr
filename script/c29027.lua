 
--辉光之针的小人族✿少名针妙丸
function c29027.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c29027.tfilter),aux.NonTuner(c29027.sfilter),1)
	c:EnableReviveLimit()
	--wan bao hammer
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29027,4))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c29027.target)
	e1:SetOperation(c29027.operation)
	c:RegisterEffect(e1)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c29027.efilter)
	c:RegisterEffect(e3)
end
function c29027.tfilter(c)
	return c:GetAttack()<=400
end
function c29027.sfilter(c)
	return c:GetAttack()<=1000
end
function c29027.filter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName==0x826 and c:IsAbleToHand()
end
function c29027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,e:GetHandler()) and Duel.IsPlayerCanDraw(1-tp) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29027,4))
		sel=Duel.SelectOption(tp,aux.Stringid(29027,0),aux.Stringid(29027,1))+1
	end
	e:SetLabel(sel)
	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else 
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	end
end
function c29027.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local gc=g:GetCount()
		if gc==0 then return end
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,gc,REASON_EFFECT)
		local tg=Duel.GetMatchingGroup(c29027.filter,tp,LOCATION_DECK,0,nil)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29027,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	else
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		local gc=g:GetCount()
		if gc==0 then return end
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(1-tp)
		Duel.BreakEffect()
		Duel.Draw(1-tp,gc-1,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(29027,3)) then
			dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c29027.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
