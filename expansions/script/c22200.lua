 
--七曜-火水木金土符「贤者之石」
--你这萝莉控。看什么看说的就是你
function c22200.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22200.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22200,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22200.acttg)
	e2:SetOperation(c22200.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22200.actcon)
	c:RegisterEffect(e3)
	--self destroy
    local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c22200.tdcon)
	e4:SetOperation(c22200.tdop)
	c:RegisterEffect(e4)
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22200,1))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c22200.thcon)
	e7:SetTarget(c22200.thtg)
	e7:SetOperation(c22200.thop)
	c:RegisterEffect(e7)
end
function c22200.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22200)==1
end
function c22200.actfilter1(c)
	return c:IsSetCard(0x178) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c22200.actfilter2(c)
	return c:IsSetCard(0x179) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c22200.actfilter3(c)
	return c:IsSetCard(0x180) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c22200.actfilter4(c)
	return c:IsSetCard(0x181) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c22200.actfilter5(c)
	return c:IsSetCard(0x182) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsAbleToHandAsCost() and c:IsFaceup()
end
function c22200.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22200.actfilter1,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c22200.actfilter2,tp,LOCATION_SZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(c22200.actfilter3,tp,LOCATION_SZONE,0,1,nil)
				and Duel.IsExistingMatchingCard(c22200.actfilter4,tp,LOCATION_SZONE,0,1,nil)
					and Duel.IsExistingMatchingCard(c22200.actfilter5,tp,LOCATION_SZONE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(22200,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22200.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,c22200.actfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22200.actfilter2,tp,LOCATION_SZONE,0,1,1,nil)
	local g3=Duel.SelectMatchingCard(tp,c22200.actfilter3,tp,LOCATION_SZONE,0,1,1,nil)
	local g4=Duel.SelectMatchingCard(tp,c22200.actfilter4,tp,LOCATION_SZONE,0,1,1,nil)
	local g5=Duel.SelectMatchingCard(tp,c22200.actfilter5,tp,LOCATION_SZONE,0,1,1,nil)
	local sg=Group.CreateGroup()
		sg:Merge(g1)
		sg:Merge(g2)
		sg:Merge(g3)
		sg:Merge(g4)
		sg:Merge(g5)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
			if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
				e:GetHandler():RegisterFlagEffect(2220000,RESET_EVENT+0xff0000,0,0)
				Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22200.dactfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x811)
end
function c22200.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22200.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22200.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c22200.tdop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(222000,RESET_EVENT+0x1fe0000,0,0)
	local c=e:GetHandler()
	if e:GetHandler():GetFlagEffect(222000)==2 then 
		Duel.SendtoGrave(c,REASON_EFFECT) end
end
function c22200.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_SPELLCASTER)
end
function c22200.thfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x208) and c:IsAbleToHand() and c:IsLevelBelow(5)
end
function c22200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22200.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22200.thop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22200.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
