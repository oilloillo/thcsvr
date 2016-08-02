--姐姐大人 保登摩卡
function c431403.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c431403.mfilter,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(431403,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c431403.limcon)
	e2:SetTarget(c431403.limtg)
	e2:SetOperation(c431403.limop)
	c:RegisterEffect(e2)
	--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(431403,1))
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(c431403.atkcon)
	e8:SetCountLimit(1)
	e8:SetTarget(c431403.atktg)
	e8:SetOperation(c431403.atkop)
	c:RegisterEffect(e8)
end
function c431403.mfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c431403.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c431403.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c431403.chainlm)
end
function c431403.chainlm(e,rp,tp)
	return tp==rp
end
function c431403.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c431403.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c431403.aclimit(e,re,tp)
	return re:GetHandler():IsOnField()
end
function c431403.atkfilter(c,e,tp)
	return c:IsControler(tp) and (not e or c:IsRelateToEffect(e)) and  c:IsFaceup()
end
function c431403.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c431403.atkfilter,1,nil,nil,1-tp)
end
function c431403.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c431403.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c431403.atkfilter,nil,e,1-tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(-1000)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetCountLimit(1)
		e5:SetValue(c431403.valcon)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5)
	end
function c431403.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
