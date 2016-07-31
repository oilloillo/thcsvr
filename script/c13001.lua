 
--梦想恋爱的魔女 爱莲
function c13001.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c13001.atkop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c13001.con)
	e2:SetOperation(c13001.op)
	c:RegisterEffect(e2)
end
function c13001.filter1(c)
	return c:IsPreviousLocation(LOCATION_SZONE)
end
function c13001.filter2(c,tp)
	return (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsPreviousLocation(LOCATION_SZONE)) and c:GetReasonPlayer()==tp
end
function c13001.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(c13001.filter1,1,nil) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c13001.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13001.filter2,1,nil,tp)
end
function c13001.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,13001)==0 then 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetCondition(c13001.drcon)
	e2:SetOperation(c13001.drop)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,13001,RESET_PHASE+PHASE_END,0,1)
	end
end
function c13001.drcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,13001)~=0
end
function c13001.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,13001)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
