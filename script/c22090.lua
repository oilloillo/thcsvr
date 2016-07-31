 
--妖精之湖
function c22090.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22090,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c22090.lvop)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x999))
	e3:SetValue(200)
	c:RegisterEffect(e3)
	--atk down
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c22090.con)
	e4:SetTarget(c22090.tg)
	e4:SetOperation(c22090.op)
	c:RegisterEffect(e4)
end
function c22090.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c22090.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c22090.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do	
		    local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_UPDATE_ATTACK)
		    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		    e1:SetValue(-400)
		    sc:RegisterEffect(e1)
		    local e2=e1:Clone()
		    e2:SetCode(EFFECT_UPDATE_DEFENCE)
		    sc:RegisterEffect(e2)
		    sc=g:GetNext()
		end
	end
end
function c22090.lvtg(e,c)
	return c:GetFieldID()<=e:GetLabel() and c:GetDefence()==900
end
function c22090.cfilter(c)
	return c:IsFaceup() and c:GetDefence()==900
end
function c22090.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local lv=Duel.GetMatchingGroupCount(c22090.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		local g,fid=g:GetMaxGroup(Card.GetFieldID)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c22090.lvtg)
		e1:SetValue(lv)
		e1:SetLabel(fid)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
