--厄符『厄神大人的生理节律』
function c23081.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetTarget(c23081.atktg1)
	e1:SetOperation(c23081.atkop)
	c:RegisterEffect(e1)
	--atk negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23081,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c23081.atkcon)
	e2:SetCost(c23081.cost)
	e2:SetTarget(c23081.atktg2)
	e2:SetOperation(c23081.atkop)
	c:RegisterEffect(e2)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetDescription(aux.Stringid(23081,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c23081.drcost)
	e4:SetTarget(c23081.drtg)
	e4:SetOperation(c23081.drop)
	c:RegisterEffect(e4)
end
function c23081.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local p=1
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tp~=Duel.GetTurnPlayer() and Duel.CheckLPCost(tp,200) then t[p]=aux.Stringid(23081,0) p=p+1 end
	if e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c23081.filter,tp,0x6,0,1,e:GetHandler())
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_EXTRA,0,nil)<=6 and Duel.IsPlayerCanDraw(tp,2) then
		t[p]=aux.Stringid(23081,1) p=p+1
	end
	if p>1 then t[p]=aux.Stringid(23081,3) p=p+1 end
	if p<2 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(23081,2))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(23081,0)
	if opt==0 then
		e:SetLabel(1)
		Duel.PayLPCost(tp,200)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
		e:GetHandler():RegisterFlagEffect(23081,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	elseif opt==1 then
		e:SetLabel(2)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		c23081.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	else
		return
	end
end
function c23081.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetControler()~=tp
end
function c23081.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,200) end
	Duel.PayLPCost(tp,200)
end
function c23081.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(23081)==0 and Duel.IsPlayerCanDiscardDeck(tp,1) end
	e:SetLabel(1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c23081.atkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local a=Duel.GetAttacker()
		if not a:IsRelateToBattle() then return end
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
		Duel.NegateAttack()
	elseif e:GetLabel()==2 then
		c23081.drop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c23081.filter(c)
	return c:IsSetCard(0x113) and c:IsAbleToGraveAsCost()
end
function c23081.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c23081.filter,tp,0x6,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c23081.filter,tp,0x6,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c23081.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_EXTRA,0,nil)<=6 and Duel.IsPlayerCanDraw(tp,2) end
	e:SetLabel(2)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c23081.drop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=2 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-tp,g)
end
