--命莲寺墓地
function c26100.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(26100,0))
	e1:SetRange(LOCATION_SZONE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1)
	e1:SetCost(c26100.cost)
	e1:SetTarget(c26100.thtg)
	e1:SetOperation(c26100.thop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26100,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c26100.cost2)
	e2:SetTarget(c26100.target)
	e2:SetOperation(c26100.operation)
	c:RegisterEffect(e2)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26100,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c26100.damcon)
	e4:SetTarget(c26100.damtg)
	e4:SetOperation(c26100.damop)
	c:RegisterEffect(e4)
end
function c26100.thfilter(c)
	return ((c:IsType(TYPE_RITUAL) and c:IsSetCard(0x208) and c:GetLevel()==3) or c:IsSetCard(0x306)) and c:IsAbleToHand()
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c26100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
		return g:GetCount()>0 end
	local tc=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil):Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	if tc:IsLevelBelow(4) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c26100.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26100.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26100.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c26100.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c26100.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if e:GetLabel()==1 then
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			local sg=g:RandomSelect(1-tp,1)
			sg:AddCard(e:GetHandler())
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

function c26100.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local rg=Group.CreateGroup()
	local flag=0
	local zc=g:GetFirst()
	while zc do
		if Duel.IsExistingMatchingCard(c26100.filter,tp,LOCATION_HAND,0,1,zc) then 
			flag=1 
			rg:AddCard(zc)
		end
		zc=g:GetNext()
	end
	if chk==0 then return flag>0 end
	local rc=rg:Select(tp,1,1,nil)
	Duel.Release(rc,REASON_COST)
	if rc:GetFirst():IsType(TYPE_RITUAL) then
		e:SetLabel(2)
	else
		e:SetLabel(0)
	end
end
function c26100.filter(c)
	return c:IsSetCard(0x208) and c:IsSummonable(true,nil) and c:GetLevel()==4
end
function c26100.ffilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c26100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26100.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26100.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26100.filter,tp,LOCATION_HAND,0,1,1,nil,e)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(26100,3))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetReset(RESET_EVENT+RESET_TOFIELD)
	if tc then
		tc:RegisterEffect(e1)
		Duel.Summon(tp,tc,true,nil)
		if e:GetLabel()==2 then
			local g=Duel.SelectMatchingCard(tp,c26100.ffilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c26100.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c26100.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_RITUAL)*150
		+Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)*50
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c26100.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
