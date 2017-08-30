--幻✿艾丽
function c14075.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14075,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	e1:SetCondition(c14075.ntcon)
	e1:SetOperation(c14075.ntop)
	c:RegisterEffect(e1)
	--battle destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14075,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCountLimit(1,14075)
	e2:SetCondition(c14075.condition)
	e2:SetTarget(c14075.target)
	e2:SetOperation(c14075.operation)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14075,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,14075)
	e3:SetCondition(c14075.thcon)
	e3:SetTarget(c14075.thtg)
	e3:SetOperation(c14075.thop)
	c:RegisterEffect(e3)
end
function c14075.ntcon(e,c)
	if c==nil then return true end
	return c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.CheckLPCost(c:GetControler(),500)
end
function c14075.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
end
function c14075.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c14075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER):GetClassCount(Card.GetCode)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c14075.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER):GetClassCount(Card.GetCode)
	local rd=Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	Duel.Recover(tp,rd,REASON_EFFECT)
end
function c14075.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c14075.thfilter(c)
	return c:IsSetCard(0x112) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c14075.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14075.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14075.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14075.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
