--地灵活性弹
local M = c999705
local Mid = 999705
function M.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0, 0x1e0)
	e1:SetCost(M.cost)
	e1:SetTarget(M.target)
	e1:SetOperation(M.activate)
	c:RegisterEffect(e1)
end

function M.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end

function M.costfilter(c, e, dg)
	if not c:IsSetCard(0xaa5) and not (c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1) then return false end
	local a=0
	if dg:IsContains(c) then a=1 end
	if c:GetEquipCount()==0 then return dg:GetCount()-a>=1 end
	local eg=c:GetEquipGroup()
	local tc=eg:GetFirst()
	while tc do
		if dg:IsContains(tc) then a=a+1 end
		tc=eg:GetNext()
	end
	return dg:GetCount()-a>=1
end

function M.tgfilter(c, e)
	return c:IsDestructable() and c:IsCanBeEffectTarget(e)
end

function M.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc~=e:GetHandler() and chkc:GetControler()~=tp end
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return false end
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetReleaseGroup(tp)
			local dg=Duel.GetMatchingGroup(M.tgfilter, tp, 0, LOCATION_ONFIELD, e:GetHandler(), e)
			local res=rg:IsExists(M.costfilter, 1, e:GetHandler(), e, dg)
			return res
		else
			return Duel.IsExistingTarget(Card.IsDestructable, tp, 0, LOCATION_ONFIELD, 1, e:GetHandler())
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetReleaseGroup(tp)
		local dg=Duel.GetMatchingGroup(M.tgfilter, tp, 0, LOCATION_ONFIELD, e:GetHandler(), e)
		Duel.Hint(HINT_SELECTMSG,tp, HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp, M.costfilter, 1, 1, e:GetHandler(), e, dg)
		Duel.Release(sg, REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function M.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc, REASON_EFFECT)
		Duel.Draw(tp, 1, REASON_EFFECT)
		local c=e:GetHandler()
		c:CancelToGrave()
		Duel.SendtoDeck(c, nil, 2, REASON_EFFECT)
	end
end