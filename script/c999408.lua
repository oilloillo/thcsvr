--猩红恶魔✿芙兰朵露•斯卡蕾特
function c999408.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,999408)
	e1:SetCondition(c999408.spcon)
	e1:SetOperation(c999408.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999408,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c999408.descost)
	e2:SetTarget(c999408.destg)
	e2:SetOperation(c999408.desop)
	c:RegisterEffect(e2)
	--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(22028)
	c:RegisterEffect(e3)
	--TODO: 特招限制: 才能从墓地特殊召唤: 让油大自己去修，好麻烦啊>_>
end
c999408.DescSetName = 0xa3

function c999408.spfilter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end

function c999408.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c999408.spfilter,c:GetControler(),LOCATION_ONFIELD,0,2,nil)
end

function c999408.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c999408.spfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c999408.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end

function c999408.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end

function c999408.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	local tc=g:RandomSelect(tp,1):GetFirst()

	if Duel.Destroy(tc,REASON_EFFECT)>0 then
		local tg=Duel.GetMatchingGroup(c999408.thfilter,tp,LOCATION_DECK,0,nil)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(999408,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c999408.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg:GetFirst(), tp, REASON_EFFECT)
		end
	end
end

function c999408.thfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0xa3 and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
