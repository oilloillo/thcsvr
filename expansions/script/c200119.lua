--天候-烈日
function c200119.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetDescription(aux.Stringid(200119,0))
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c200119.cost)
	e1:SetTarget(c200119.target)
	e1:SetOperation(c200119.activate)
	c:RegisterEffect(e1)
	--dam
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c200119.btg)
	e3:SetOperation(c200119.bop)
	c:RegisterEffect(e3)
end
function c200119.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	Duel.PayLPCost(tp,1200)
end
function c200119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c200119.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c200119.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,Duel.GetTurnPlayer(),500)
end
function c200119.bop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Damage(Duel.GetTurnPlayer(),500,REASON_EFFECT)
end