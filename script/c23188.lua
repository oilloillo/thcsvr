--我欲的巫女✿东风谷早苗
function c23188.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23188,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c23188.cost)
	e1:SetTarget(c23188.tg)
	e1:SetOperation(c23188.op)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23188,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,23188)
	e2:SetTarget(c23188.drtg)
	e2:SetOperation(c23188.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c23188.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c23188.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23188.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c23188.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c23188.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsCanAddCounter(0x28a,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c23188.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsCanAddCounter(0x28a,1) then return end
	e:GetHandler():AddCounter(0x28a,1)
		if Duel.GetFlagEffect(tp,23200)==0 then
			Duel.RegisterFlagEffect(tp,23200,0,0,0)
		end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c23188.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return Duel.GetFlagEffect(tp,23200)>0 and ht<1 and e:GetHandler():GetOverlayTarget()==nil end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1-ht)
end
function c23188.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ht=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ht<1 then
		Duel.Draw(p,1-ht,REASON_EFFECT)
	end
end
