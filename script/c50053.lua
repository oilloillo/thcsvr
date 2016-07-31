 
--球磨型轻巡洋舰-北上
function c50053.initial_effect(c)
	local temp = 0
	while temp<6 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50053,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c50053.negcon)
	e2:SetCost(c50053.negcost)
	e2:SetTarget(c50053.negtg)
	e2:SetOperation(c50053.negop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50053,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c50053.target)
	e3:SetOperation(c50053.op)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
	--damage
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(50053,0))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BATTLED)
	e7:SetCondition(c50053.damcon)
	e7:SetOperation(c50053.damop)
	c:RegisterEffect(e7)
end
function c50053.tfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x4bb)
end
function c50053.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g:IsExists(c50053.tfilter,1,nil)
end
function c50053.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c50053.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c50053.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c50053.filter(c,val)
	local lv=c:GetLevel()
	return lv>val and c:IsSetCard(0x4bb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c50053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc~=e:GetHandler() and tc:IsSetCard(0xc4bb) and tc:GetControler()==tp
		and Duel.IsExistingMatchingCard(c50053.filter,tp,LOCATION_DECK,0,1,nil,tc:GetLevel()) end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50053.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50053.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c50053.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
end
function c50053.damop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(500530,RESET_EVENT+0x1fe0000,0,0)
end
