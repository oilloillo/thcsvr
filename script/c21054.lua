 
--幻胧月睨「LunaticRedEyes」
function c21054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change attack target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCondition(c21054.reccon)
	e2:SetTarget(c21054.rectg)
	e2:SetOperation(c21054.recop)
	c:RegisterEffect(e2)
	--effect indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c21054.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--extra attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21054,0))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c21054.target)
	e5:SetOperation(c21054.operation)
	c:RegisterEffect(e5)
	--cost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetOperation(c21054.costop)
	c:RegisterEffect(e6)
	--indestructable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function c21054.reccon(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 and Duel.GetAttackTarget()~=nil
		and Duel.GetAttackTarget():IsControler(tp) and Duel.GetAttackTarget():IsSetCard(0x255)
end
function c21054.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,Duel.GetAttacker())
	Duel.HintSelection(sg)
end
function c21054.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end
function c21054.indtg(e,c)
	return c:IsCode(21012)
end
function c21054.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x256) and c:GetOriginalLevel()>=6 and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c21054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21054.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21054.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21054.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21054.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c21054.costop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>=1200 then
		Duel.PayLPCost(tp,1200)
	else
		Duel.SetLP(tp,0)
	end
end
