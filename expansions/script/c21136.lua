--枭的夜鸣声 米斯蒂娅✿萝蕾拉
function c21136.initial_effect(c)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21136,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21136)
	e2:SetCost(c21136.cost)
	e2:SetTarget(c21136.settg)
	e2:SetOperation(c21136.setop)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21136,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c21136.hdcon)
	e3:SetTarget(c21136.hdtg)
	e3:SetOperation(c21136.hdop)
	c:RegisterEffect(e3)
end
function c21136.rfilter(c)
	return c:GetLevel()==2
end
function c21136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c21136.rfilter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c21136.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c21136.filter(c)
	return c:IsSetCard(0x522b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c21136.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c21136.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c21136.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c21136.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c21136.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c21136.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c21136.cfilter,1,nil,1-tp)
end
function c21136.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() 
		and eg:IsExists(Card.IsAbleToRemove,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c21136.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(g)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetOperation(c21136.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c21136.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	g:DeleteGroup()
end
