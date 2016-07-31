 
--大合葬「灵车大协奏曲改」
function c20119.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20119.target)
	e1:SetOperation(c20119.operation)
	c:RegisterEffect(e1)
	if not c20119.global_check then
		c20119.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c20119.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c20119.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsSetCard(0x163) then
		Duel.RegisterFlagEffect(rp,20119,RESET_PHASE+PHASE_END,0,1)
	end
end
function c20119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20119)>4
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,0xf,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0xf)
end
function c20119.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()>0 then
		local sg1=g1:RandomSelect(1-tp,1)
		sg:Merge(sg1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g2:GetCount()>0 then
		sg:Merge(g2)
	end
	local g3=Duel.GetDecktopGroup(1-tp,1)
	if g3:GetCount()>0 then
		sg:Merge(g3)
	end
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
