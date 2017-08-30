 
--永夜返 -破晓明星-
function c21119.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21119.cost)
	e1:SetTarget(c21119.target)
	e1:SetOperation(c21119.activate)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21119,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c21119.scost)
	e2:SetOperation(c21119.sop)
	c:RegisterEffect(e2)
end
function c21119.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21119)==0 end
	Duel.RegisterFlagEffect(tp,21119,RESET_PHASE+PHASE_END,0,1)
end
function c21119.filter(c)
	return c:IsSetCard(0x257) and c:IsFaceup() and c:IsType(TYPE_TRAP)
end
function c21119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c21119.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21119.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_SZONE,LOCATION_SZONE)
	local fg=g:Filter(c21119.filter,e:GetHandler())
	if fg:GetCount()==0 then return end
	Duel.SendtoGrave(fg,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(p,fg:GetCount(),REASON_EFFECT)
end
function c21119.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.GetFlagEffect(tp,21119)==0 end
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,21119,RESET_PHASE+PHASE_END,0,1)
end
function c21119.sop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTarget(c21119.tg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c21119.efilter)
	Duel.RegisterEffect(e1,tp)
end
function c21119.tg(e,c)
	return c:IsSetCard(0x256)
end
function c21119.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
