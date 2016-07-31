 
--绯想娘 比那名居天子
function c25016.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),6,2)
	--...
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25016,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c25016.condition)
	e1:SetCost(c25016.cost)
	e1:SetTarget(c25016.target)
	e1:SetOperation(c25016.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25016,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c25016.drcon)
	e2:SetTarget(c25016.drtg)
	e2:SetOperation(c25016.drop)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c25016.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_MAIN1
	--return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()~=PHASE_MAIN2 and Duel.GetCurrentPhase()~=PHASE_END
end
function c25016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c25016.filter(c)
	return c:IsPosition(POS_DEFENCE)
end
function c25016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25016.filter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c25016.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c25016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_MUST_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(25016,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			tc=sg:GetNext()
		end
		local be=Effect.CreateEffect(c)
		be:SetType(EFFECT_TYPE_FIELD)
		be:SetCode(EFFECT_CANNOT_EP)
		be:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		be:SetTargetRange(0,1)
		be:SetCondition(c25016.becon)
		be:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(be,tp)
	end
end
function c25016.befilter(c)
	return c:GetFlagEffect(25016)~=0 and c:IsAttackable()
end
function c25016.becon(e)
	return Duel.IsExistingMatchingCard(c25016.befilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c25016.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
		and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp and c:GetOverlayCount()~=0
end
function c25016.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c25016.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
