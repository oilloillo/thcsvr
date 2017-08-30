 
--蓬莱-千年幻想乡✿八意永琳
function c21074.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21074.ttcon)
	e1:SetOperation(c21074.ttop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21074,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c21074.condition)
	e2:SetTarget(c21074.target)
	e2:SetOperation(c21074.operation)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--lp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21074,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c21074.lptg)
	e4:SetOperation(c21074.lpop)
	c:RegisterEffect(e4)
end

c21074.DescSetName=0x258

function c21074.ntfilter(c)
	return (c:IsSetCard(0x256) or c:IsSetCard(0x258)) and c:IsAbleToRemoveAsCost()
end
function c21074.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		--and Duel.IsExistingMatchingCard(c21074.ntfilter,c:GetControler(),LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c21074.ntfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c21074.ntfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
function c21074.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Group.CreateGroup()
	--local g1=Duel.SelectMatchingCard(tp,c21074.ntfilter,c:GetControler(),LOCATION_HAND,0,1,1,nil)
	--	g:Merge(g1)
	local g2=Duel.SelectMatchingCard(tp,c21074.ntfilter,c:GetControler(),LOCATION_MZONE,0,1,1,nil)
		g:Merge(g2)
	local g3=Duel.SelectMatchingCard(tp,c21074.ntfilter,c:GetControler(),LOCATION_GRAVE,0,1,1,nil)
		g:Merge(g3)
	if g:IsExists(Card.IsLevelAbove,1,nil,6) then
		e:GetHandler():RegisterFlagEffect(21074,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21074.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(21074)~=0
end
function c21074.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21074.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c21074.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,0x41)==0x41 and e:GetHandler():GetReasonPlayer()==1-tp end
end
function c21074.lpop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCondition(c21074.damcon)
	e1:SetOperation(c21074.damop)
	Duel.RegisterEffect(e1,tp)
end
function c21074.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c21074.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end
