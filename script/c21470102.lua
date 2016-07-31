 
--妖魔书变化 别有隐情的情书
function c21470102.initial_effect(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21470102,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c21470102.con1)
	e1:SetTarget(c21470102.target)
	e1:SetOperation(c21470102.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21470102,0))
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c21470102.con2)
	e2:SetTarget(c21470102.target)
	e2:SetOperation(c21470102.op)
	c:RegisterEffect(e2)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21470102,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c21470102.ccon1)
	e2:SetTarget(c21470102.target2)
	e2:SetOperation(c21470102.cop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c21470102.ccon2)
	e3:SetOperation(c21470102.cop2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_SET_CONTROL)
	e4:SetValue(c21470102.ctval)
	c:RegisterEffect(e4)
	e2:SetLabelObject(e4)
	e3:SetLabelObject(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21470102,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetCountLimit(1,21470102)
	e5:SetCondition(c21470102.spcon)
	e5:SetTarget(c21470102.sptg)
	e5:SetOperation(c21470102.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(21470102,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_ACTIVATE)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCountLimit(1,21470102)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(c21470102.spcon)
	e7:SetTarget(c21470102.sptg)
	e7:SetOperation(c21470102.spop)
	c:RegisterEffect(e7)
end
function c21470102.con1(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c21470102.con2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0x742)
end
function c21470102.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and c:IsOnField()
end
function c21470102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg and c21470102.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c21470102.filter(tg) and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c21470102.eqlimit(e,c)
	return e:GetOwner()==c and e:GetLabelObject():GetHandler():IsFaceup()
end
function c21470102.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateAttack()
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetLabelObject(e)
		e1:SetValue(c21470102.eqlimit)
		c:RegisterEffect(e1)
	end
end
function c21470102.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local tc=e:GetHandler():GetEquipTarget()
	if tc then Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0) end
end
function c21470102.ccon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return tp==Duel.GetTurnPlayer() and tc:IsControler(tp)
end
function c21470102.cop1(e,tp,eg,ep,ev,re,r,rp)
	local ce=e:GetLabelObject()
	if ce then ce:SetValue(1-tp) end
end
function c21470102.ccon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return tp~=Duel.GetTurnPlayer() and tc:IsControler(1-tp)
end
function c21470102.cop2(e,tp,eg,ep,ev,re,r,rp)
	local ce=e:GetLabelObject()
	if ce then ce:SetValue(tp) end
end
function c21470102.ctval(e,c)
	return e:GetHandlerPlayer()
end
function c21470102.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and (c:IsSetCard(0x742) or c:GetPreviousCodeOnField()==21470999)
end
function c21470102.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if Duel.GetTurnPlayer()==tp then tc=Duel.GetAttackTarget() end
	return eg:IsExists(c21470102.cfilter,1,nil,tp) and ((bit.band(r,REASON_EFFECT)==0 and tc:IsType(TYPE_EFFECT)) 
	or (bit.band(r,REASON_EFFECT)~=0 and re and re:GetHandler():IsType(TYPE_MONSTER)))
end
function c21470102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21470102,0,0x2742,4,0,2000,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21470102.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21470102,0,0x2742,4,0,2000,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER+TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_ZOMBIE)
		c:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_DARK)
		c:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetValue(4)
		c:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_ATTACK)
		e5:SetValue(0)
		c:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_SET_BASE_DEFENCE)
		e6:SetValue(2000)
		c:RegisterEffect(e6,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENCE)
		local tc=c
		if re then tc=re:GetHandler()
		else 
			tc=Duel.GetAttacker()
			if Duel.GetTurnPlayer()==tp then tc=Duel.GetAttackTarget() end
		end
		c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
	end
end