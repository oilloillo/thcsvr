--黄金拼图-猪熊阳子
function c4031105.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4031105,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,4031105)
	e1:SetCost(c4031105.cost)
	e1:SetTarget(c4031105.thtg)
	e1:SetOperation(c4031105.thop)
	c:RegisterEffect(e1)
     --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4031105,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,4031105)
	e2:SetCost(c4031105.thcost)
	e2:SetTarget(c4031105.target2)
	e2:SetOperation(c4031105.activate2)
	c:RegisterEffect(e2)
end
function c4031105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c4031105.tdfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsLevelBelow(3) and c:IsRace(RACE_FAIRY) 
end
function c4031105.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c4031105.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4031105.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c4031105.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c4031105.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,nil,0,REASON_EFFECT+REASON_RETURN)
	end
end
function c4031105.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost() and c:IsLevelBelow(3)
end
function c4031105.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c4031105.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4031105.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4031105.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c4031105.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(4031105,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(c4031105.discon)
		e1:SetOperation(c4031105.disop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c4031105.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(4031105)==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(tc) and re:IsActiveType(TYPE_MONSTER)
end
function c4031105.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end