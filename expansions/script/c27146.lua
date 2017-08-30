--大声『激动Yahoo』
function c27146.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27146.damtg)
	e1:SetOperation(c27146.damop)
	c:RegisterEffect(e1)
	if c27146.was==nil then
		c27146.was=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetOperation(c27146.op)
		Duel.RegisterEffect(e3,0)
	end
end
function c27146.op(e,tp,eg,ep,ev,re,r,rp)
	local ap=Duel.GetAttacker():GetControler()
	Duel.RegisterFlagEffect(ap,27146,RESET_PHASE+PHASE_END,0,2)
end
function c27146.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x527)
end
function c27146.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local dam=500
	if Duel.GetMatchingGroupCount(c27146.cfilter,tp,LOCATION_MZONE,0,nil)>0 then
		dam=dam*2
	end
	if Duel.GetFlagEffect(1-tp,27146)>0 then
		dam=dam*2
	end
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c27146.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
