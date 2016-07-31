 
--河城美取
function c24030.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2)
	--ban
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24030,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c24030.cost)
	e1:SetOperation(c24030.operation)
	e1:SetLabel(-1)
	c:RegisterEffect(e1)
	--forbidden
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c24030.con)
	e2:SetTarget(c24030.bantg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c24030.con)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c24030.bantg)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function c24030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c24030.bantg(e,c)
	local code = e:GetLabelObject():GetLabel()
	return code~=-1 and c:IsCode(code) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function c24030.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
end
function c24030.con(e,c)
	return e and e:GetHandler() and e:GetHandler():IsOnField()
end
