 
--绯想✿红美铃
function c200018.initial_effect(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(22011)
	c:RegisterEffect(e1)
	--field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200018,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_BATTLE_START,0)
	e2:SetCondition(c200018.con1)
	e2:SetOperation(c200018.op1)
	c:RegisterEffect(e2)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetCondition(c200018.con2)
	e4:SetTarget(c200018.tg2)
	e4:SetOperation(c200018.op2)
	c:RegisterEffect(e4)
	if not c200018.global_check then
		c200018.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_CHAIN_ACTIVATING)
		ge:SetOperation(c200018.negop)
		Duel.RegisterEffect(ge,0)
	end
end
function c200018.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckPhaseActivity() and Duel.GetCurrentChain()==0
end
function c200018.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200118)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200018.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c200018.filter2(c)
	return c:IsCode(200218) and c:IsAbleToHand()
end
function c200018.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c200018.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c200018.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200018.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c200018.negfilter(c)
	return c:GetOriginalCode()==200018 and c:IsLocation(LOCATION_MZONE) and c:IsPosition(POS_FACEDOWN_DEFENCE)
end
function c200018.negop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c200018.negfilter,nil)
		if g:GetCount()>0 then
			Duel.NegateActivation(ev)
			Duel.ChangePosition(g,POS_FACEUP_ATTACK)
			local tc=g:GetFirst()
			while tc do 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
				e1:SetValue(900)
				tc:RegisterEffect(e1)
				tc=g:GetNext()
			end
		end
	end
end