 
--命莲-搜符「金子探测器」
function c26053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26053,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c26053.cost)
	e2:SetTarget(c26053.target)
	e2:SetOperation(c26053.operation)
	c:RegisterEffect(e2)
end
function c26053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c26053.filter(c,val)
	local lv=c:GetLevel()
	return lv>=0 and lv>val and c:IsSetCard(0x251) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c26053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsSetCard(0x251) and tc:GetControler()==tp
		and Duel.IsExistingMatchingCard(c26053.filter,tp,LOCATION_DECK,0,1,nil,tc:GetLevel()) end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26053.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26053.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
