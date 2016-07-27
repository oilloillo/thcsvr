--禁弹『铭刻过去的时计』
function c999405.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c999405.activate)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c999405.cost)
	e2:SetTarget(c999405.tg)
	e2:SetOperation(c999405.op)
	c:RegisterEffect(e2)
end
c999405.DescSetName = 0xa3 

function c999405.filter(c,e,tp,zc1,zc2)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local flag = true
	if c:IsCode(999405) then return false end
	if c:IsType(TYPE_MONSTER) then
		flag = zc1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) and c:IsSetCard(0x815)
	else
		flag = zc2 and c:IsSSetable() and mt and mt.DescSetName == 0xa3
	end
	return flag
end

function c999405.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local zc1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local zc2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local g1=Duel.GetMatchingGroup(c999405.filter,tp,LOCATION_GRAVE,0,nil,e,tp,zc1,zc2)
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(999405,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g1:Select(tp,1,1,nil)
		if sg:GetCount()~=1 then return end
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENCE)
		else
			Duel.SSet(tp,sg)
		end
	end
end

function c999405.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c999405.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_GRAVE) or chkc:IsLocation(LOCATION_REMOVED)) and chkc:IsControler(tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c999405.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)~=1 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end