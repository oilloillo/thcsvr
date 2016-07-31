 
--妖云『平安时代的黑云』
function c26059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26059,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26059.target)
	e1:SetOperation(c26059.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26059,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c26059.condition)
	e2:SetCost(c26059.cost)
	e2:SetOperation(c26059.activate)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--cloud
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26059,2))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c26059.ctcon)
	e3:SetTarget(c26059.cttg)
	e3:SetOperation(c26059.operation)
	c:RegisterEffect(e3)
end
function c26059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetTurnPlayer()~=tp
		and e:GetHandler():IsAbleToGraveAsCost()
		and Duel.SelectYesNo(tp,aux.Stringid(26059,0)) then
		e:SetLabel(1)
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	else
		e:SetLabel(0)
	end
end
function c26059.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c26059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c26059.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c26059.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g2=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return g1>g2 and g1>1
end
function c26059.filter(c)
	return c:IsFaceup()
end
function c26059.filter2(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c26059.filter3(c)
	return c:IsSetCard(0x251) or c:IsSetCard(0x251c)
end
function c26059.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26059.filter,tp,0,LOCATION_MZONE,1,nil) 
		and Duel.IsExistingMatchingCard(c26059.filter3,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.GetMatchingGroup(c26059.filter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tg,1,0,0)
end
function c26059.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c26059.filter2,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end
	local tg=g:GetMinGroup(Card.GetAttack)
	local sg=Duel.GetMatchingGroup(c26059.filter3,tp,LOCATION_HAND,0,nil):Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,567)
	local op=Duel.AnnounceNumber(1-tp,1,2,3,4,5,6)
	Duel.ConfirmCards(1-tp,tc)
	if op~=tc:GetLevel() and tg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local sc=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sc)
			Duel.GetControl(sc:GetFirst(),tp)
	else if op~=tc:GetLevel() and tg:GetCount()==1 then
				Duel.GetControl(tg:GetFirst(),tp)
			end
		end
	Duel.ShuffleHand(tp)
end
