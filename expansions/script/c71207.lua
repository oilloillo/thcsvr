--恩赐游戏?
function c71207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c71207.target1)
	e1:SetOperation(c71207.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(c71207.handcon)
	c:RegisterEffect(e4)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71207,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetLabel(1)
	e2:SetCost(c71207.cost2)
	e2:SetTarget(c71207.target2)
	e2:SetOperation(c71207.operation)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71207,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,71207)
	e3:SetCondition(c71207.drcon)
	e3:SetTarget(c71207.drtg)
	e3:SetOperation(c71207.drop)
	c:RegisterEffect(e3)
	if not c71207.global_check then
		c71207.global_check=true
		c71207[0]=0
		c71207[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c71207.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_MATERIAL_CHECK)
		ge2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge2:SetValue(c71207.valcheck)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c71207.clearop)
		Duel.RegisterEffect(ge3,0)
	end
end
function c71207.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x711) 
end
function c71207.handcon(e)
	return Duel.GetMatchingGroupCount(c71207.cfilter2,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>0
end
function c71207.cfilter(c)
	return c:IsSetCard(0x711) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost() and c:IsType(TYPE_RITUAL)
end
function c71207.afilter(c)
	return c:IsSetCard(0x711) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c71207.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c71207.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c71207.afilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(71207,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c71207.cfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
		end
		Duel.SendtoDeck(g,nil,2,REASON_COST)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		e:GetHandler():RegisterFlagEffect(71207,RESET_PHASE+PHASE_END,0,1)
	else
		e:SetCategory(0)
		e:SetLabel(0)
	end
end
function c71207.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71207.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71207.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71207.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c71207.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c71207.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(71207)==0
		and Duel.IsExistingMatchingCard(c71207.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(71207,RESET_PHASE+PHASE_END,0,1)
end
function c71207.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c71207.splimit(e,c)
	return not c:IsSetCard(0x711)
end
function c71207.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if bit.band(tc:GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL then
		local p=tc:GetSummonPlayer()
		c71207[p]=c71207[p]+e:GetLabel()
	end
end
function c71207.valcheck(e,c)
	local ct=c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x711)
	e:GetLabelObject():SetLabel(ct)
end
function c71207.clearop(e,tp,eg,ep,ev,re,r,rp)
	c71207[0]=0
	c71207[1]=0
end
function c71207.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c71207[tp]>0
end
function c71207.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c71207[tp]) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c71207[tp])
end
function c71207.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,c71207[tp],REASON_EFFECT)
end