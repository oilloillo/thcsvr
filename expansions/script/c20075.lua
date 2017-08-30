 
--战符「小小军势」
function c20075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20075.cost)
	e1:SetTarget(c20075.target)
	e1:SetOperation(c20075.activate)
	c:RegisterEffect(e1)
end
function c20075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c20075.costfilter(c,e,dg)
	if not c:IsSetCard(0x186) or not c:IsLevelBelow(3) or not c:IsRace(RACE_MACHINE) then return false end
	local a=0
	if dg:IsContains(c) then a=1 end
	if c:GetEquipCount()==0 then return dg:GetCount()-a>=2 end
	local eg=c:GetEquipGroup()
	local tc=eg:GetFirst()
	while tc do
		if dg:IsContains(tc) then a=a+1 end
		tc=eg:GetNext()
	end
	return dg:GetCount()-a>=2
end
function c20075.tgfilter(c,e)
	return c:IsDestructable() and c:IsCanBeEffectTarget(e) --and c:IsFaceup()
end
function c20075.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc:IsFaceup() end
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetReleaseGroup(tp)
			local dg=Duel.GetMatchingGroup(c20075.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
			local res=rg:IsExists(c20075.costfilter,1,e:GetHandler(),e,dg)
			return res
		else
			return Duel.IsExistingTarget(c20075.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler(),e)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetReleaseGroup(tp)
		local dg=Duel.GetMatchingGroup(c20075.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp,c20075.costfilter,1,1,e:GetHandler(),e,dg)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20075.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler(),e)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c20075.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
