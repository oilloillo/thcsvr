--疵符『破裂的护符』
function c23082.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c23082.target)
	e1:SetOperation(c23082.activate)
	c:RegisterEffect(e1)
	--predraw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23082,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c23082.condition1)
	e2:SetTarget(c23082.target1)
	e2:SetOperation(c23082.operation1)
	c:RegisterEffect(e2)
end
function c23082.filter(c)
	return c:IsFaceup()
end
function c23082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,0,0x4e,nil)>0
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)<=15 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0x4e)
end
function c23082.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()>0 then
		local sg1=g1:RandomSelect(1-tp,1)
		sg:Merge(sg1)
	end
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g2:GetCount()>0 then
		local sg2=g2:RandomSelect(1-tp,1)
		sg:Merge(sg2)
	end
	local g3=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g3:GetCount()>0 then
		local sg3=g3:RandomSelect(1-tp,1)
		sg:Merge(sg3)
	end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	local gt=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	local g=Duel.GetDecktopGroup(1-tp,gt)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)+gt
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
function c23082.condition1(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c23082.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c23082.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
