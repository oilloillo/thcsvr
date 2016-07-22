--天候-黄砂
function c200118.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetTarget(c200118.tg)
	e1:SetOperation(c200118.op)
	c:RegisterEffect(e1)
end
function c200118.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	local turnp=Duel.GetTurnPlayer()
	if chk==0 then return (tp==turnp and at and at:IsStatus(STATUS_BATTLE_DESTROYED))
	or (tp~=turnp and a:IsStatus(STATUS_BATTLE_DESTROYED)) end
	if tp==turnp then e:SetLabelObject(at)
	else e:SetLabelObject(a) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetLabelObject(),1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c200118.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	local tc=e:GetLabelObject()
	if tc and tc:IsAbleToDeck() then 
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then Duel.Damage(1-tp,500,REASON_EFFECT) end
	end
end