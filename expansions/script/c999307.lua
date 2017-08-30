--叶符「落叶狂扫」
function c999307.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(999307,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCost(c999307.cost)
	e1:SetTarget(c999307.tg)
	e1:SetOperation(c999307.op)
	c:RegisterEffect(e1)
	-- 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetDescription(aux.Stringid(999307,1))	
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,999307)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetTarget(c999307.tg2)
	e2:SetOperation(c999307.op2)
	c:RegisterEffect(e2)
end

c999307.DescSetName=0xa2

function c999307.filter(c)
	return c:IsRace(RACE_PLANT) and c:IsFaceup()
end

function c999307.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) 
		and Duel.IsExistingMatchingCard(c999307.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.PayLPCost(tp,800)
end

function c999307.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and Card.IsDestructable(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end

function c999307.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c999307.tgfilter(c,tp)
	return c:IsCode(999300) and c:GetPreviousControler()==tp
end

function c999307.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c999307.tgfilter,1,nil,tp) end
end

function c999307.op2(e,tp,eg,ep,ev,re,r,rp)
	local val = 0
	val = Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0)
	if val > 3 then val = 3 end
	Duel.DiscardDeck(tp,val,REASON_EFFECT)
	
	val = Duel.GetFieldGroupCount(tp, 0, LOCATION_DECK)
	if val > 3 then val = 3 end
	Duel.DiscardDeck(1-tp,val,REASON_EFFECT)
end