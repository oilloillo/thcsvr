--幽灵引者✿魂魄妖梦
function c20242.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Nef.AddXyzProcedureWithDesc(c,nil,4,2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20242,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20242.cost1)
	e1:SetTarget(c20242.target1)
	e1:SetOperation(c20242.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c20242.reptg)
	c:RegisterEffect(e2)
	--spirit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ADD_TYPE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(aux.TargetBoolFunction(c20242.sfilter))
	c:RegisterEffect(e5)
end
function c20242.sfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_TOKEN)
end
function c20242.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1=e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	local c2=Duel.CheckReleaseGroup(tp,c20242.sfilter,1,nil)
	if chk==0 then return c1 or c2 end
	local opt=2
	if c1 then opt=0 end
	if c2 then opt=1 end
	if c1 and c2 then opt=Duel.SelectOption(tp,aux.Stringid(20242,1),aux.Stringid(20242,2)) end
	if opt==0 then 
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		local sg=Duel.SelectReleaseGroup(tp,c20242.sfilter,1,1,nil)
		Duel.Release(sg,REASON_COST)
	end
end
function c20242.filter(c)
	return c:IsAbleToGrave() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c20242.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c20242.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c20242.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c20242.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local g2=Duel.SelectTarget(tp,c20242.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c20242.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c20242.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(20242,3)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
