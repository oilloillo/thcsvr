 
--七曜-水符「水母公主」
function c22137.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22137.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22137,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22137.acttg)
	e2:SetOperation(c22137.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22137.actcon)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(c22137.rdcon)
	e4:SetCost(c22137.cost)
	e4:SetOperation(c22137.rdop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22137,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c22137.drcost)
	e5:SetTarget(c22137.drtg)
	e5:SetOperation(c22137.drop)
	c:RegisterEffect(e5)
end
function c22137.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(22137)==1
end
function c22137.actfilter(c)
	return c:IsSetCard(0x179) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22137.exfilter(c)
	return c:IsCode(22200) and c:GetFlagEffect(2220000)>0
end
function c22137.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22137.actfilter,tp,LOCATION_SZONE,0,2,nil) or
		(Duel.IsExistingMatchingCard(c22137.exfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22137.actfilter,tp,LOCATION_SZONE,0,1,nil)) end
	e:GetHandler():RegisterFlagEffect(22137,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22137.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=0
	if Duel.IsExistingMatchingCard(c22137.exfilter,tp,LOCATION_SZONE,0,1,nil) 
		then ct=1
	else ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22137.actfilter,tp,LOCATION_SZONE,0,ct,ct,nil)
		if Duel.SendtoGrave(g,REASON_MATERIAL)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22137.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22137.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22137.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22137.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c22137.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,221370)<1 end
	Duel.RegisterFlagEffect(tp,221370,RESET_PHASE+PHASE_END,0,1)
end
function c22137.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1600,REASON_EFFECT)
end
function c22137.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2200) and Duel.GetFlagEffect(tp,221370)<1 end
	Duel.PayLPCost(tp,2200) 
	Duel.RegisterFlagEffect(tp,221370,RESET_PHASE+PHASE_END,0,1)
end
function c22137.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22137.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
