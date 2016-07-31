--大地之祟神✿洩矢诹访子
function c23168.initial_effect(c)
	c:EnableReviveLimit()
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23168,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c23168.cttg)
	e1:SetOperation(c23168.ctop)
	c:RegisterEffect(e1)
	--controler
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23168,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c23168.descon)
	e2:SetTarget(c23168.destg)
	e2:SetOperation(c23168.desop)
	c:RegisterEffect(e2)
end
function c23168.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c23168.ctop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	if Duel.SelectYesNo(1-tp,aux.Stringid(23168,2)) then
		tc:AddCounter(0x28a,2)
		local cp=tc:GetControler()
		if Duel.GetFlagEffect(cp,23200)==0 then
			Duel.RegisterFlagEffect(cp,23200,0,0,0)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		e1:SetOperation(c23168.tgop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c23168.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c23168.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c23168.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c23168.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetCounter(0x28a)>0 and bc:IsControlerCanBeChanged()
end
function c23168.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c23168.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) and Duel.ChangePosition(c,POS_FACEUP_DEFENCE)>0 then
		local bc=c:GetBattleTarget()
		if bc:IsRelateToBattle() and not Duel.GetControl(bc,tp) then
			if not bc:IsImmuneToEffect(e) and bc:IsAbleToChangeControler() then
				Duel.Destroy(bc,REASON_EFFECT)
			end
		end
	end
end
