 
--七曜-水符「湖葬」
function c22152.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22152.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22152,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22152.acttg)
	e2:SetOperation(c22152.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22152.actcon)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22152,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetCondition(c22152.drcon)
	e4:SetCost(c22152.drcost)
	e4:SetOperation(c22152.drop)
	c:RegisterEffect(e4)
end
function c22152.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(22152)==1
end
function c22152.actfilter(c)
	return c:IsSetCard(0x179) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22152.exfilter(c)
	return c:IsCode(22200) and c:GetFlagEffect(2220000)>0
end
function c22152.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22152.actfilter,tp,LOCATION_SZONE,0,3,nil) or
		(Duel.IsExistingMatchingCard(c22152.exfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22152.actfilter,tp,LOCATION_SZONE,0,2,nil)) end
	e:GetHandler():RegisterFlagEffect(22152,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22152.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=0
	if Duel.IsExistingMatchingCard(c22152.exfilter,tp,LOCATION_SZONE,0,1,nil) 
		then ct=2
	else ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22152.actfilter,tp,LOCATION_SZONE,0,ct,ct,nil)
		if Duel.SendtoGrave(g,REASON_MATERIAL)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22152.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22152.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22152.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22152.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c22152.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.PayLPCost(tp,800) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22152.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsSetCard(0x177) and tc:IsType(TYPE_SPELL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,2,nil)
		Duel.SendtoGrave(dg,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
