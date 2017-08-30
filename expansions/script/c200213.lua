 
--符器-宵越之铜钱
function c200213.initial_effect(c)
	c:SetUniqueOnField(1,0,200213)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetTarget(c200213.atktg1)
	e1:SetOperation(c200213.atkop)
	c:RegisterEffect(e1)
	--indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(c200213.valcon)
	c:RegisterEffect(e4)
	--neg
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200213,0))
	e2:SetCategory(CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c200213.atkcon)
	e2:SetTarget(c200213.atktg2)
	e2:SetOperation(c200213.atkop)
	c:RegisterEffect(e2)
	--maintain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c200213.mtop)
	c:RegisterEffect(e3)
end
function c200213.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c200213.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c200213.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tp~=Duel.GetTurnPlayer() then
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	end
end
function c200213.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(1)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c200213.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
--	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(200213,0))
--	local coin=Duel.SelectOption(1-tp,aux.Stringid(200213,1),aux.Stringid(200213,2))
	local coin=Duel.TossCoin(tp,1)
	if coin==1 then Duel.NegateAttack() 
	else Duel.Recover(tp,300,REASON_EFFECT) end
end
function c200213.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.SelectYesNo(tp,aux.Stringid(200213,3)) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SKIP_BP)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	else
		local coin=Duel.TossCoin(tp,1)
		if coin==0 then Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) end
	end
end